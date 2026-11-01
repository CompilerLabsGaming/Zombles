local Module = {}

-- sound_IDs
Module.SoundIDs = {
	default = "5279459236",
	pew = "5958405572",
	laser_rifle_shoot = "9060205449",
	short_laser_reload = "9060040486",
	long_laser_reload = "9058751039",
	gunshot = "6862108495",
	empty_clip = "132464034",
	gun_reload = "138084889",
	oof = "17755696142",
	beep = "762117042",
	alarm = "418308086",
	omaewa = "1255922819",
	song__frozen_glow = "114853109003442"
}

-- global sound volume modifier
Module.VALUE__master_volume = 0.5
export type VolumeControls = {
	MasterVolume: number
}

-- sound type
export type LoadedSound = {
	Name: string,
	AssetID: string,
	SoundInstance: Sound
}

-- load all sounds
function Module.LOAD__sounds()
	-- load sounds
	for name, asset_ID in pairs(Module.sound_IDs) do
		-- create sound variable
		local sound: LoadedSound = {}

		-- setup sound properies
		sound.SoundInstance = Instance.new("Sound", game.SoundService)
		sound.AssetID = Module.CALCULATE__sound_asset_ID_string(asset_ID)
		sound.Name = name
		sound.SoundInstance.Name = name
	end
end

-- calculate roblox asset ID string
function Module.CALCULATE__sound_asset_ID_string(asset_ID: string): string
	return "rbxassetid://" .. asset_ID
end

-- get sound asset id
function Module.GET__sound_asset_ID(searching_for: string): string
	-- search for sound
	for name: string, member: string in pairs(Module.sound_IDs) do
		-- check for name
		if name == searching_for then
			-- match
			return Module.CALCULATE__sound_asset_ID_string(Module.sound_IDs[name])
		end
	end

	-- sound not found
	return Module.CALCULATE__sound_asset_ID_string(Module.sound_IDs["default"])
end

-- play any sound
function Module.PLAY__sound(name: string, volume: number, pace: number, has_audio_overlap: boolean)
	-- open sound
	local desired_sound: Sound = game.SoundService:FindFirstChild(name)
	if not desired_sound then
		warn("Sound not found: " .. name)
		return
	end

	-- check for audio overlap
	if has_audio_overlap then
		-- create new sound and place it in sound service
		local new_sound = desired_sound:Clone()
		new_sound.Parent = game.SoundService
		desired_sound = new_sound
	end

	-- configure sound
	desired_sound.Volume = volume * Module.VALUE__master_volume
	desired_sound.PlaybackSpeed = pace

	-- play sound
	desired_sound:Play()

	-- delete if necessary
	if has_audio_overlap then
		-- delete sound after it is done playing
		desired_sound.Ended:Connect(function()
			desired_sound:Destroy()
		end)
	end
end

-- play a sound at it's original pace
function Module.PLAY__sound__default_settings(name: string)
	Module.PLAY__sound(name, 1, 1, true)
end

return Module
