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

-- gun configurations
Module.Configurations = {
	PhotonPistol = {
		Appearance = {
			Name = "Photon Pistol",
			PowerColor = Module.Colors.PowerCyan,
			Parts = {
				{ PartName = "PowerMeter", PartShape = Enum.PartType.Block, Material = Enum.Material.Neon, PositionalOffset = Vector3.new(0, 0.33, 0), Rotation = Vector3.new(0, 0, 0), Size = Vector3.new(0.2, 0.25, 1.75), Color = Module.Colors.PowerCyan },
				{ PartName = "Barrel", PartShape = Enum.PartType.Block, Material = Enum.Material.Plastic, PositionalOffset = Vector3.new(0, 0, 0), Rotation = Vector3.new(0, 0, 0), Size = Vector3.new(0.75, 0.75, 2.25), Color = Module.Colors.BarrelBlack },
				{ PartName = "Scope", PartShape = Enum.PartType.Block, Material = Enum.Material.Plastic, PositionalOffset = Vector3.new(0, 0.4, -0.8), Rotation = Vector3.new(0, 0, 0), Size = Vector3.new(0.25, 0.4, 0.5), Color = Module.Colors.BarrelBlack },
				{ PartName = "Stock", PartShape = Enum.PartType.Block, Material = Enum.Material.Plastic, PositionalOffset = Vector3.new(0, -0.5, 0.75), Rotation = Vector3.new(math.rad(75), 0, 0), Size = Vector3.new(0.7, 0.8, 0.5), Color = Module.Colors.BarrelBlack }
			}
		},
		Firing = {
			DamageDealt = 25,
			ShotRate = 0.2,
			ShotsPerClip = 10,
			ReloadTime = 1.0,
			FiringSound = "LaserRifleShoot",
			ReloadSound = "LongLaserReload"
		}
	},
	PlasmaRifle = {
		Appearance = {
			Name = "Plasma Rifle",
			PowerColor = Module.Colors.PowerPurple,
			Parts = {
				{ PartName = "PowerMeter", PartShape = Enum.PartType.Block, Material = Enum.Material.Neon, PositionalOffset = Vector3.new(0, 0.33, 0), Rotation = Vector3.new(0, 0, 0), Size = Vector3.new(0.2, 0.25, 2.25), Color = Module.Colors.PowerPurple },
				{ PartName = "Barrel", PartShape = Enum.PartType.Block, Material = Enum.Material.Plastic, PositionalOffset = Vector3.new(0, 0, 0), Rotation = Vector3.new(0, 0, 0), Size = Vector3.new(0.75, 0.75, 3), Color = Module.Colors.BarrelBlack },
				{ PartName = "Scope", PartShape = Enum.PartType.Block, Material = Enum.Material.Plastic, PositionalOffset = Vector3.new(0, 0.4, -1), Rotation = Vector3.new(0, 0, 0), Size = Vector3.new(0.25, 0.4, 0.5), Color = Module.Colors.BarrelBlack },
				{ PartName = "Stock", PartShape = Enum.PartType.Block, Material = Enum.Material.Plastic, PositionalOffset = Vector3.new(0, -0.5, 1), Rotation = Vector3.new(math.rad(75), 0, 0), Size = Vector3.new(0.7, 0.8, 0.5), Color = Module.Colors.BarrelBlack },
				{ PartName = "Clip", PartShape = Enum.PartType.Block, Material = Enum.Material.Plastic, PositionalOffset = Vector3.new(0, -0.5, -0.75), Rotation = Vector3.new(math.rad(345), 0, 0), Size = Vector3.new(0.7, 1, 0.5), Color = Module.Colors.BarrelBlack }
			}
		},
		Firing = {
			DamageDealt = 200,
			ShotRate = 0.05,
			ShotsPerClip = 50,
			ReloadTime = 3.0,
			FiringSound = "LaserRifleShoot",
			ReloadSound = "LongLaserReload"
		}
	},
	AetherBolt = {
		Appearance = {
			Name = "Aether Bolt",
			PowerColor = Module.Colors.PowerYellow,
			Parts = {
				{ PartName = "PowerMeter", PartShape = Enum.PartType.Block, Material = Enum.Material.Neon, PositionalOffset = Vector3.new(0, 0.33, 0), Rotation = Vector3.new(0, 0, 0), Size = Vector3.new(0.2, 0.25, 2.25), Color = Module.Colors.PowerYellow },
				{ PartName = "Barrel", PartShape = Enum.PartType.Block, Material = Enum.Material.Plastic, PositionalOffset = Vector3.new(0, 0, 0), Rotation = Vector3.new(0, 0, 0), Size = Vector3.new(0.75, 0.75, 3), Color = Module.Colors.BarrelBlack },
				{ PartName = "Scope", PartShape = Enum.PartType.Block, Material = Enum.Material.Plastic, PositionalOffset = Vector3.new(0, 0.4, -1), Rotation = Vector3.new(0, 0, 0), Size = Vector3.new(0.25, 0.4, 0.5), Color = Module.Colors.BarrelBlack },
				{ PartName = "Stock", PartShape = Enum.PartType.Block, Material = Enum.Material.Plastic, PositionalOffset = Vector3.new(0, -0.5, 1), Rotation = Vector3.new(math.rad(75), 0, 0), Size = Vector3.new(0.7, 0.8, 0.5), Color = Module.Colors.BarrelBlack },
				{ PartName = "Clip", PartShape = Enum.PartType.Block, Material = Enum.Material.Plastic, PositionalOffset = Vector3.new(0, -0.5, -0.75), Rotation = Vector3.new(math.rad(345), 0, 0), Size = Vector3.new(0.7, 1, 0.5), Color = Module.Colors.BarrelBlack },
				{ PartName = "SparePower", PartShape = Enum.PartType.Block, Material = Enum.Material.Neon, PositionalOffset = Vector3.new(0, -0.5, -0.6), Rotation = Vector3.new(math.rad(345), 0, 0), Size = Vector3.new(0.5, 0.9, 0.5), Color = Module.Colors.PowerYellow }
			}
		},
		Firing = {
			DamageDealt = 200,
			ShotRate = 0.05,
			ShotsPerClip = 50,
			ReloadTime = 3.0,
			FiringSound = "LaserRifleShoot",
			ReloadSound = "LongLaserReload"
		}
	}
}

-- get a list of all possible gun types
function Module.GetGunTypeList()
	-- setup output
	local output = {}
	
	-- for each member
	for name, member in pairs(Module.Configurations) do
		-- insert member
		table.insert(output, name)
	end
	
	return output
end

return Module
