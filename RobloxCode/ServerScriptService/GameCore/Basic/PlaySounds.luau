local Module = {}

-- SoundIDs
Module.SoundIDs = {
	Default = "5279459236",
	Pew = "5958405572",
	LaserRifleShoot = "9060205449",
	ShortLaserReload = "9060040486",
	LongLaserReload = "9058751039",
	GunShot = "6862108495",
	EmptyClip = "132464034",
	GunReload = "138084889",
	Oof = "17755696142",
	Beep = "762117042",
	Alarm = "418308086",
	Omaewa = "1255922819",
	Song_FrozenGlow = "114853109003442"
}

-- global sound volume modifier
Module.MasterVolume = 0.5
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
function Module.LoadAllSounds()
	-- load sounds
	for name, asset_ID in pairs(Module.SoundIDs) do
		-- create sound variable
		local sound: LoadedSound = nil

		-- setup sound properies
		sound.SoundInstance = Instance.new("Sound", game.SoundService)
		sound.AssetID = Module.CreateSoundAssetIDString(asset_ID)
		sound.Name = name
		sound.SoundInstance.Name = name

		-- create sound asset
	end
end

-- calculate roblox asset ID string
function Module.CreateSoundAssetIDString(asset_ID: string): string
	return "rbxassetid://" .. asset_ID
end

-- get sound asset id
function Module.GET__sound_asset_ID(searching_for: string): string
	-- search for sound
	for name: string, member: string in pairs(Module.SoundIDs) do
		-- check for name
		if name == searching_for then
			-- match
			return Module.CreateSoundAssetIDString(Module.SoundIDs[name])
		end
	end

	-- sound not found
	return Module.CreateSoundAssetIDString(Module.SoundIDs["default"])
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
	desired_sound.Volume = volume * Module.MasterVolume
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
