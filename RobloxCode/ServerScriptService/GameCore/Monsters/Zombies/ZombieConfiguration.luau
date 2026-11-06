local module = {}

--[[
	Zombie Configuration Data
]]

-- generate colors
module.zombie_colors = {
	normal_brown = Color3.fromRGB(106, 57, 9),
	ash_brown = Color3.fromRGB(107, 63, 25),
	baby_blue = Color3.fromRGB(152, 194, 219),
	light_blue = Color3.fromRGB(59, 226, 244),
	dark_blue = Color3.fromRGB(6, 10, 254),
	medium_green = Color3.fromRGB(58, 125, 21),
	bright_green = Color3.fromRGB(0, 255, 0),
	magenta = Color3.fromRGB(227, 37, 244),
	ash_skin = Color3.fromRGB(52, 46, 31),
	dark_black = Color3.fromRGB(0, 0, 0),
	silver = Color3.fromRGB(200, 200, 200),
	noob_yellow = Color3.fromRGB(255, 255, 0),
	noob_green = Color3.fromRGB(0, 161, 0),
	noob_blue = Color3.fromRGB(0, 0, 255),
	frost_white = Color3.fromRGB(242, 243, 243)
}

-- generate faces
module.zombie_faces = {
	normal = "rbxassetid://7157327144",
	rainbow = "rbxassetid://3361955796",
	squidward = "rbxassetid://26487044"
}

-- generate styles
module.zombie_styles = {
	-- normal zombie
	normal = {
		display_name = "Zombie",
		colors = {
			skin = module.zombie_colors.medium_green,
			pants = module.zombie_colors.normal_brown,
			shirt = module.zombie_colors.normal_brown
		},
		face = module.zombie_faces.normal,
		decoration = {},
		max_health = 100,
		damage = {
			dealt = 4,
			rate = 1
		},
		worth = 1
	},
	
	-- noob zombie
	noob = {
		display_name = "Noob Zombie",
		colors = {
			skin = module.zombie_colors.noob_yellow,
			pants = module.zombie_colors.noob_green,
			shirt = module.zombie_colors.dark_blue,
		},
		face = module.zombie_faces.rainbow,
		decoration = {},
		max_health = 10,
		damage = {
			dealt = 1,
			rate = 5
		},
		worth = 1
	},

	-- ash zombie
	ash = {
		display_name = "Ash Zombie",
		colors = {
			skin = module.zombie_colors.ash_skin,
			pants = module.zombie_colors.ash_brown,
			shirt = module.zombie_colors.ash_brown
		},
		face = module.zombie_faces.normal,
		decoration = {
			"fire"
		},
		max_health = 200,
		damage = {
			dealt = 4,
			rate = 1
		},
		worth = 3
	},

	-- ice zombie
	ice = {
		display_name = "Ice Zombie",
		colors = {
			skin = module.zombie_colors.light_blue,
			pants = module.zombie_colors.dark_blue,
			shirt = module.zombie_colors.dark_blue
		},
		face = module.zombie_faces.normal,
		decoration = {},
		max_health = 200,
		damage = {
			dealt = 7,
			rate = 1
		},
		worth = 3
	},
	
	-- frost zombie
	frost = {
		display_name = "Frost Zombie",
		colors = {
			skin = module.zombie_colors.frost_white,
			pants = module.zombie_colors.frost_white,
			shirt = module.zombie_colors.frost_white
		},
		face = module.zombie_faces.normal,
		decoration = {},
		max_health = 200,
		damage = {
			dealt = 7,
			rate = 1
		},
		worth = 5
	},

	-- radiated zombie
	radiated = {
		display_name = "Radiated Zombie",
		colors = {
			skin = module.zombie_colors.bright_green,
			pants = module.zombie_colors.silver,
			shirt = module.zombie_colors.silver
		},
		face = module.zombie_faces.normal,
		decoration = {},
		max_health = 300,
		damage = {
			dealt = 10,
			rate = 1
		},
		worth = 5
	},
	
	-- squidward zombie
	squidward = {
		display_name = "Zombward",
		colors = {
			skin = module.zombie_colors.baby_blue,
			pants = module.zombie_colors.baby_blue,
			shirt = module.zombie_colors.ash_brown
		},
		face = module.zombie_faces.squidward,
		decoration = {},
		max_health = 100,
		damage = {
			dealt = 5,
			rate = 2
		},
		worth = 5
	},
	
	-- jeff zombie
	jeff = {
		display_name = "Jeff",
		colors = {
			skin = module.zombie_colors.magenta,
			pants = module.zombie_colors.magenta,
			shirt = module.zombie_colors.magenta
		},
		face = module.zombie_faces.rainbow,
		decoration = {},
		max_health = 100000,
		damage = {
			dealt = 0,
			rate = 10
		},
		worth = 1000
	}
}

-- get a list of all possible zombie types
function module.get_zombie_types_list()
	-- setup output
	local output = {}
	
	-- for each member
	for name, member in pairs(module.zombie_styles) do
		-- add name
		table.insert(output, name)
	end

	return output
end

return module
