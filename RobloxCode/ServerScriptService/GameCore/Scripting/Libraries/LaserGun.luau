local Module = {}

--[[
	Gun Configuration Data
]]

-- models
Module.Models = {
	Pistol = "rbxassetid://131117193100393",
	Rifle = "rbxassetid://128778891985444"
}

-- colors
Module.Colors = {
	-- gun colors
	BarrelBlack = Color3.fromRGB(30, 30, 30),
	
	-- power meter colors
	PowerCyan = Color3.fromRGB(0, 255, 255),
	PowerBlue = Color3.fromRGB(0, 0, 255),
	PowerPurple = Color3.fromRGB(255, 0, 255),
	PowerYellow = Color3.fromRGB(255, 248, 34)
}

-- gun configuration structures
export type GunPart = {
	partCategory: string, -- power meter, barrel, clip, scope, etc
	partName: string,
	partShape: Enum.PartType,
	material: Enum.Material,
	positionalOffset: Vector3,
	rotation: Vector3,
	size: Vector3,
	color: Color3
}
export type GunAppearance = {
	displayName: string,
	powerColor: Color3,
	parts: { GunPart }
}
export type GunStats = {
	damageDealt: number,
	shotRate: number,
	shotsPerClip: number,
	reloadTime: number,
	firingSound: string,
	reloadSound: string
}
export type GunConfiguration = {
	internalName: string,
	appearance: GunAppearance,
	stats: GunStats
}

-- gun configuration scripts
Module.BuildScripts = {}
function Module.BuildScripts.Pack_GunPart(partName: string, partShape: Enum.PartType, material: Enum.Material, positionalOffset: Vector3, rotation: Vector3, size: Vector3, color: Color3): GunPartAppearance
	local output: GunPart = nil
	
	-- setup values
	output.partName = partName
	output.partShape = partShape
	output.material = material
	output.positionalOffset = positionalOffset
	output.rotation = rotation
	output.size = size
	output.color = color
	
	return output
end
function Module.BuildScripts.Pack_GunAppearance(displayName: string, powerColor: Color3, ...: GunPart): GunAppearance
	local output: GunAppearance = nil
	
	-- setup values
	output.displayName = displayName
	output.powerColor = powerColor
	output.parts = {}
	for index, part in { ... } do
		table.insert(output.parts, part)
	end
	
	return output
end
function Module.BuildScripts.Pack_GunConfiguration(internalName: string, appearance: GunAppearance, stats: GunStats): GunConfiguration
	local output: GunConfiguration = nil

	-- setup values
	output.internalName = internalName
	output.appearance = appearance
	output.stats = stats

	return output
end
function Module.BuildScripts.CreateGun_PhotonPistol(parent): Model
	local output: Model = nil
	
	-- setup looks
	local gunColor = Module.Colors.BarrelBlack
	local plasmaColor = Module.Colors.PowerBlue
	local materialPlastic = Enum.Material.Plastic
	local materialNeon = Enum.Material.Neon

	

	-- build gun
	output = Instance.new("Model", parent)
	
	return output
end

-- gun configurations
Module.configurations = {
	photon_pistol = {
		appearance = {
			name = "Photon Pistol",
			power_color = Module.Colors.PowerCyan,
			parts = {
				{ part_name = "PowerMeter", part_shape = Enum.PartType.Block, material = Enum.Material.Neon, positional_offset = Vector3.new(0, 0.33, 0), rotation = Vector3.new(0, 0, 0), size = Vector3.new(0.2, 0.25, 1.75), color = Module.Colors.PowerCyan },
				{ part_name = "Barrel", part_shape = Enum.PartType.Block, material = Enum.Material.Plastic, positional_offset = Vector3.new(0, 0, 0), rotation = Vector3.new(0, 0, 0), size = Vector3.new(0.75, 0.75, 2.25), color = Module.Colors.BarrelBlack },
				{ part_name = "Scope", part_shape = Enum.PartType.Block, material = Enum.Material.Plastic, positional_offset = Vector3.new(0, 0.4, -0.8), rotation = Vector3.new(0, 0, 0), size = Vector3.new(0.25, 0.4, 0.5), color = Module.Colors.BarrelBlack },
				{ part_name = "Stock", part_shape = Enum.PartType.Block, material = Enum.Material.Plastic, positional_offset = Vector3.new(0, -0.5, 0.75), rotation = Vector3.new(math.rad(75), 0, 0), size = Vector3.new(0.7, 0.8, 0.5), color = Module.Colors.BarrelBlack }
			}
		},
		firing = {
			damage_dealt = 25,
			shot_rate = 0.2,
			shots_per_clip = 10,
			reload_time = 1.0,
			firing_sound = "laser_rifle_shoot",
			reload_sound = "long_laser_reload"
		}
	},
	plasma_rifle = {
		appearance = {
			name = "Plasma Rifle",
			power_color = Module.Colors.PowerPurple,
			parts = {
				{ part_name = "PowerMeter", part_shape = Enum.PartType.Block, material = Enum.Material.Neon, positional_offset = Vector3.new(0, 0.33, 0), rotation = Vector3.new(0, 0, 0), size = Vector3.new(0.2, 0.25, 2.25), color = Module.Colors.PowerPurple },
				{ part_name = "Barrel", part_shape = Enum.PartType.Block, material = Enum.Material.Plastic, positional_offset = Vector3.new(0, 0, 0), rotation = Vector3.new(0, 0, 0), size = Vector3.new(0.75, 0.75, 3), color = Module.Colors.BarrelBlack },
				{ part_name = "Scope", part_shape = Enum.PartType.Block, material = Enum.Material.Plastic, positional_offset = Vector3.new(0, 0.4, -1), rotation = Vector3.new(0, 0, 0), size = Vector3.new(0.25, 0.4, 0.5), color = Module.Colors.BarrelBlack },
				{ part_name = "Stock", part_shape = Enum.PartType.Block, material = Enum.Material.Plastic, positional_offset = Vector3.new(0, -0.5, 1), rotation = Vector3.new(math.rad(75), 0, 0), size = Vector3.new(0.7, 0.8, 0.5), color = Module.Colors.BarrelBlack },
				{ part_name = "Clip", part_shape = Enum.PartType.Block, material = Enum.Material.Plastic, positional_offset = Vector3.new(0, -0.5, -0.75), rotation = Vector3.new(math.rad(345), 0, 0), size = Vector3.new(0.7, 1, 0.5), color = Module.Colors.BarrelBlack }
			}
		},
		firing = {
			damage_dealt = 200,
			shot_rate = 0.05,
			shots_per_clip = 50,
			reload_time = 3.0,
			firing_sound = "laser_rifle_shoot",
			reload_sound = "long_laser_reload"
		}
	},
	aetherbolt = {
		appearance = {
			name = "Aether Bolt",
			power_color = Module.Colors.PowerYellow,
			parts = {
				{ part_name = "PowerMeter", part_shape = Enum.PartType.Block, material = Enum.Material.Neon, positional_offset = Vector3.new(0, 0.33, 0), rotation = Vector3.new(0, 0, 0), size = Vector3.new(0.2, 0.25, 2.25), color = Module.Colors.PowerYellow },
				{ part_name = "Barrel", part_shape = Enum.PartType.Block, material = Enum.Material.Plastic, positional_offset = Vector3.new(0, 0, 0), rotation = Vector3.new(0, 0, 0), size = Vector3.new(0.75, 0.75, 3), color = Module.Colors.BarrelBlack },
				{ part_name = "Scope", part_shape = Enum.PartType.Block, material = Enum.Material.Plastic, positional_offset = Vector3.new(0, 0.4, -1), rotation = Vector3.new(0, 0, 0), size = Vector3.new(0.25, 0.4, 0.5), color = Module.Colors.BarrelBlack },
				{ part_name = "Stock", part_shape = Enum.PartType.Block, material = Enum.Material.Plastic, positional_offset = Vector3.new(0, -0.5, 1), rotation = Vector3.new(math.rad(75), 0, 0), size = Vector3.new(0.7, 0.8, 0.5), color = Module.Colors.BarrelBlack },
				{ part_name = "Clip", part_shape = Enum.PartType.Block, material = Enum.Material.Plastic, positional_offset = Vector3.new(0, -0.5, -0.75), rotation = Vector3.new(math.rad(345), 0, 0), size = Vector3.new(0.7, 1, 0.5), color = Module.Colors.BarrelBlack },
				{ part_name = "SparePower", part_shape = Enum.PartType.Block, material = Enum.Material.Neon, positional_offset = Vector3.new(0, -0.5, -0.6), rotation = Vector3.new(math.rad(345), 0, 0), size = Vector3.new(0.5, 0.9, 0.5), color = Module.Colors.PowerYellow }
			}
		},
		firing = {
			damage_dealt = 200,
			shot_rate = 0.05,
			shots_per_clip = 50,
			reload_time = 3.0,
			firing_sound = "laser_rifle_shoot",
			reload_sound = "long_laser_reload"
		}
	}
}

-- get a list of all possible gun types
function Module.get_gun_type_list()
	-- setup output
	local output = {}
	
	-- for each member
	for name, member in pairs(Module.configurations) do
		-- insert member
		table.insert(output, name)
	end
	
	return output
end

return Module
