--[[
	Zombie Script
]]

--[[
	File Scoped Variables
]]

-- last attack
local LastPrickle = 0

-- modules
local SoundModule = require(game:WaitForChild("ServerScriptService").GameCore.Basic.PlaySounds)
local PlayerModule = require(game:WaitForChild("ServerScriptService").GameCore.Players.Players)

--[[
	Wrapper Functions
]]

local function GetScriptingFolder()
	return script.Parent.Parent
end

local function GetModel()
	return script.Parent.Parent.Parent
end

local function IsZombieActivated()
	return GetScriptingFolder().Values.Activated.Value
end

local function GetLeftArm()
	return GetModel().LeftArm
end

local function GetRightArm()
	return GetModel().RightArm
end

local function GetLeftLeg()
	return GetModel().LeftLeg
end

local function GetRightLeg()
	return GetModel().RightLeg
end

local function GetTorso()
	return GetModel().Torso
end

local function GetHead()
	return GetModel().Head
end

local function GetHumanoid()
	return GetModel().Humanoid
end

local function GetHealth()
	return GetScriptingFolder().Values.Health.Value
end

local function GetDamageDealt()
	return GetScriptingFolder().Values.DamageDealt.Value
end

local function GetDamageRate()
	return GetScriptingFolder().Values.DamageRate.Value
end

local function GetZombieType()
	return GetScriptingFolder().Values.ZombieType.Value
end

local function GetWorth()
	return GetScriptingFolder().Values.Worth.Value
end

local function IsAZombie()
	return GetModel():WaitForChild("Humanoid") and GetHumanoid() and GetHumanoid().IsZombie and GetHumanoid().IsZombie.Value
end

local function SetActivated(activated)
	GetScriptingFolder().Values.Activated.Value = activated
end

local function SetHealth(value)
	GetScriptingFolder().Values.Health.Value = value
end

local function SetDamageDealt(damage)
	GetScriptingFolder().Values.DamageDealt.Value = damage
end

local function SetDamageRate(seconds)
	GetScriptingFolder().Values.DamageRate.Value = seconds
end

local function SetDisplayName(new_name)
	GetModel().Humanoid.DisplayName = new_name
end

local function SetHeadFire(enabled)
	GetModel().Head.Fire.Enabled = enabled
end

local function SetFace(asset_ID)
	GetModel().Head.Decal.Texture = asset_ID
end

local function SetWorth(worth)
	GetScriptingFolder().Values.Worth.Value = worth
end

--[[
	Deal Damage
]]

-- check if enough time has passed so that the zombie can deal damage
local function ZombieCanDamage()
	return os.time() - LastPrickle > GetDamageRate()
end

-- try to deal damage
local function DoPrickle(partTouching)
	local humanoid = partTouching.Parent:FindFirstChildWhichIsA("Humanoid")
	
	-- check if humanoid exists
	if humanoid and IsZombieActivated() and not IsAZombie() and ZombieCanDamage() then
		-- deal damage
		humanoid.Health -= GetDamageDealt()
		
		-- reset timer
		LastPrickle = os.time()
	end
end

-- do jeff damage
local function DoJeffPrickle(partTouching)
	local humanoid = partTouching.Parent:FindFirstChildWhichIsA("Humanoid")

	-- check if humanoid exists
	if humanoid and IsZombieActivated() and not IsAZombie() and ZombieCanDamage() and GetZombieType() == "Jeff" then
		-- deal damage
		humanoid.Health -= GetDamageDealt()

		-- reset timer
		LastPrickle = os.time()
		
		-- jeff's power awakens
		-- open guis
		local playerGui = game:GetService("Players"):GetPlayerFromCharacter(partTouching.Parent):WaitForChild("PlayerGui")
		local screenGui = Instance.new("ScreenGui", playerGui)
		local imageGui = Instance.new("ImageLabel", screenGui)
		local imageGui2 = Instance.new("ImageLabel", screenGui)
		
		-- setup first image
		imageGui.Size = UDim2.new(1, 0, 1, 0)
		imageGui.Position = UDim2.new(0, 0, 0, 0)
		imageGui.Image = "rbxassetid://141447418"
		imageGui.ImageTransparency = 0
		imageGui.BackgroundTransparency = 1
		
		-- play death sound
		SoundModule.PlaySound_DefaultSettings("Omaewa")
		
		-- wait to display glowing eyes
		task.wait(4)
		
		-- setup second image
		imageGui2.Size = UDim2.new(1, 0, 1, 0)
		imageGui2.Position = UDim2.new(0, 0, 0, 0)
		imageGui2.Image = "rbxassetid://368111294"
		imageGui2.ImageTransparency = 0
		imageGui2.BackgroundTransparency = 1
		
		-- kill player
		humanoid.Health = 0
	end
end

--[[
	Take Damage
]]

local function DoDeath()
	-- DEBUG
	print("Zombie Died!")
	
	-- give money
	PlayerModule.GivePlayerMoney(GetHumanoid().WhoShot.Value, GetWorth())
	
	-- deactivate zombie
	SetActivated(false)
	
	-- break joints
	for index, joint in ipairs(GetTorso():GetJoints()) do
		joint:Destroy()
	end
	
	-- fade parts out
	for transparency = 0, 1, 0.1 do
		-- fade parts
		for index, part in ipairs(GetModel():GetDescendants()) do
			-- check for part
			if part:IsA("BasePart") then
				-- fade
				part.Transparency = transparency
			end
		end
		
		-- wait
		task.wait(0.2)
	end
	
	-- disappear
	GetModel():Destroy()
end

local function IsZombieAlive()
	return (GetHealth() > 0)
end

--[[
	Configure Zombie
]]

-- setup zombie clothing decoration
local function ConfigureZombieColors(shirtColor, pantsColor, skinColor)
	-- setup part colors
	GetTorso().Color = shirtColor
	GetHead().Color = skinColor
	GetLeftArm().Color = skinColor
	GetRightArm().Color = skinColor
	GetLeftLeg().Color = pantsColor
	GetRightLeg().Color = pantsColor
end

-- setup head fire
local function SetHeadFireDecoration(enabled)
	SetHeadFire(enabled)
end

-- configure damage
local function ConfigureZombieDamage(damageDealt, damageRate)
	-- setup damage
	SetDamageDealt(damageDealt)
	SetDamageRate(damageRate)
end

-- configure zombie
local function ConfigureZombie(zombieType)
	-- get options
	local ZombieModule = require(game:GetService("ServerScriptService").GameCore.Monsters.Zombies.ZombieConfiguration)
	local StringModule = require(game:GetService("ServerScriptService").GameCore.Basic.Strings)
	
	-- configure damage
	ConfigureZombieDamage(ZombieModule.ZombieStyles[zombieType].Damage.Dealt, ZombieModule.ZombieStyles[zombieType].Damage.Rate)
	
	-- configure health
	SetHealth(ZombieModule.ZombieStyles[zombieType].MaxHealth)
	
	-- dress zombie
	ConfigureZombieColors(ZombieModule.ZombieStyles[zombieType].Colors.Shirt, ZombieModule.ZombieStyles[zombieType].Colors.Pants, ZombieModule.ZombieStyles[zombieType].Colors.Skin)
	
	-- configure decoration
	SetDisplayName(ZombieModule.ZombieStyles[zombieType].DisplayName)
	GetHumanoid().NameDisplayDistance = 0
	SetHeadFireDecoration(StringModule.ListHasString(ZombieModule.ZombieStyles[zombieType].Decoration, "Fire"))
	SetFace(ZombieModule.ZombieStyles[zombieType].Face)
	
	-- configure worth
	SetWorth(ZombieModule.ZombieStyles[zombieType].Worth)
end

--[[
	Start Zombie
]]

-- zombie main
local function RunZombie(zombieType)
	-- setup humanoid variable
	local humanoid = GetHumanoid()

	-- setup damage
	GetLeftArm().Touched:Connect(DoPrickle)
	GetRightArm().Touched:Connect(DoPrickle)
	GetLeftArm().Touched:Connect(DoJeffPrickle)
	GetRightArm().Touched:Connect(DoJeffPrickle)

	-- configure zombie
	ConfigureZombie(zombieType)
	
	-- while zombie is alive
	while IsZombieAlive() == true do
		-- stall while not active
		while IsZombieAlive() == true and IsZombieActivated() == false do
			-- wait
			task.wait(5)
		end
		
		-- make zombie walk
		while IsZombieAlive() == true and IsZombieActivated() == true do
			-- make zombie walk
			local playerPositions = PlayerModule.GetPlayersByClosestToPoint(GetTorso().Position + Vector3.new(math.random(-10, 10), 0, math.random(-10, 10)))
			humanoid:MoveTo(playerPositions[1].position)
			
			-- sleep
			task.wait(1)
		end
		
		-- general wait
		task.wait(0.5)
	end
	
	-- zombie is dead
	DoDeath()
end

-- run zombie
RunZombie(GetZombieType())
