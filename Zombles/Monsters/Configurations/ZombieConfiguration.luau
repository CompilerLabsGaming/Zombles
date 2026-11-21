local Module = {}

--[[
	Zombie Configuration Data
]]

-- generate colors
Module.ZombieColors = {
	Normalbrown = Color3.fromRGB(106, 57, 9),
	AshBrown = Color3.fromRGB(107, 63, 25),
	BabyBlue = Color3.fromRGB(152, 194, 219),
	LightBlue = Color3.fromRGB(59, 226, 244),
	DarkBlue = Color3.fromRGB(6, 10, 254),
	MediumGreen = Color3.fromRGB(58, 125, 21),
	BrightGreen = Color3.fromRGB(0, 255, 0),
	Magenta = Color3.fromRGB(227, 37, 244),
	AshSkin = Color3.fromRGB(52, 46, 31),
	DarkBlack = Color3.fromRGB(0, 0, 0),
	Silver = Color3.fromRGB(200, 200, 200),
	NoobYellow = Color3.fromRGB(255, 255, 0),
	NoobGreen = Color3.fromRGB(0, 161, 0),
	NoobBlue = Color3.fromRGB(0, 0, 255),
	FrostWhite = Color3.fromRGB(242, 243, 243)
}

-- generate faces
Module.ZombieFaces = {
	Normal = "rbxassetid://7157327144",
	Rainbow = "rbxassetid://3361955796",
	Squidward = "rbxassetid://26487044"
}

-- generate styles
Module.ZombieStyles = {
	-- Normal zombie
	Normal = {
		DisplayName = "Zombie",
		Colors = {
			Skin = Module.ZombieColors.MediumGreen,
			Pants = Module.ZombieColors.Normalbrown,
			Shirt = Module.ZombieColors.Normalbrown
		},
		Face = Module.ZombieFaces.Normal,
		Decoration = {},
		MaxHealth = 100,
		Damage = {
			Dealt = 4,
			Rate = 1
		},
		Worth = 1
	},
	
	-- noob zombie
	Noob = {
		DisplayName = "Noob Zombie",
		Colors = {
			Skin = Module.ZombieColors.NoobYellow,
			Pants = Module.ZombieColors.NoobGreen,
			Shirt = Module.ZombieColors.NoobBlue,
		},
		Face = Module.ZombieFaces.Rainbow,
		Decoration = {},
		MaxHealth = 10,
		Damage = {
			Dealt = 1,
			Rate = 5
		},
		Worth = 1
	},

	-- ash zombie
	Ash = {
		DisplayName = "Ash Zombie",
		Colors = {
			Skin = Module.ZombieColors.AshSkin,
			Pants = Module.ZombieColors.AshBrown,
			Shirt = Module.ZombieColors.AshBrown
		},
		Face = Module.ZombieFaces.Normal,
		Decoration = {
			"Fire"
		},
		MaxHealth = 200,
		Damage = {
			Dealt = 4,
			Rate = 1
		},
		Worth = 3
	},

	-- ice zombie
	Ice = {
		DisplayName = "Ice Zombie",
		Colors = {
			Skin = Module.ZombieColors.LightBlue,
			Pants = Module.ZombieColors.DarkBlue,
			Shirt = Module.ZombieColors.DarkBlue
		},
		Face = Module.ZombieFaces.Normal,
		Decoration = {},
		MaxHealth = 200,
		Damage = {
			Dealt = 7,
			Rate = 1
		},
		Worth = 3
	},
	
	-- frost zombie
	Frost = {
		DisplayName = "Frost Zombie",
		Colors = {
			Skin = Module.ZombieColors.FrostWhite,
			Pants = Module.ZombieColors.FrostWhite,
			Shirt = Module.ZombieColors.FrostWhite
		},
		Face = Module.ZombieFaces.Normal,
		Decoration = {},
		MaxHealth = 200,
		Damage = {
			Dealt = 7,
			Rate = 1
		},
		Worth = 5
	},

	-- radiated zombie
	Radiated = {
		DisplayName = "Radiated Zombie",
		Colors = {
			Skin = Module.ZombieColors.BrightGreen,
			Pants = Module.ZombieColors.Silver,
			Shirt = Module.ZombieColors.Silver
		},
		Face = Module.ZombieFaces.Normal,
		Decoration = {},
		MaxHealth = 300,
		Damage = {
			Dealt = 10,
			Rate = 1
		},
		Worth = 5
	},
	
	-- Squidward zombie
	Squidward = {
		DisplayName = "Zombward",
		Colors = {
			Skin = Module.ZombieColors.BabyBlue,
			Pants = Module.ZombieColors.BabyBlue,
			Shirt = Module.ZombieColors.AshBrown
		},
		Face = Module.ZombieFaces.Squidward,
		Decoration = {},
		MaxHealth = 100,
		Damage = {
			Dealt = 5,
			Rate = 2
		},
		Worth = 5
	},
	
	-- jeff zombie
	Jeff = {
		DisplayName = "Jeff",
		Colors = {
			Skin = Module.ZombieColors.Magenta,
			Pants = Module.ZombieColors.Magenta,
			Shirt = Module.ZombieColors.Magenta
		},
		Face = Module.ZombieFaces.Rainbow,
		Decoration = {},
		MaxHealth = 100000,
		Damage = {
			Dealt = 0,
			Rate = 10
		},
		Worth = 1000
	}
}

-- get a list of all possible zombie types
function Module.GetAllPossibleZombieTypes()
	-- setup output
	local output = {}
	
	-- for each member
	for name, member in pairs(Module.ZombieStyles) do
		-- add name
		table.insert(output, name)
	end

	return output
end

return Module
