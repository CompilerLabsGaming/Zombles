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

-- load all sounds
function Module.LoadAllSounds()
	-- load sounds
	for name, assetID in pairs(Module.SoundIDs) do
		-- create sound in sounds module
		local sound = Instance.new("Sound", game.SoundService)

		-- setup sound properies
		sound.Name = name
		sound.SoundId = Module.CreateSoundAssetIDString(assetID)
	end
end

-- calculate roblox asset ID string
function Module.CreateSoundAssetIDString(assetID: string): string
	return "rbxassetid://" .. assetID
end

-- get sound asset id
function Module.GetSoundAssetID(searchingFor: string): string
	-- search for sound
	for name: string, member: string in pairs(Module.SoundIDs) do
		-- check for name
		if name == searchingFor then
			-- match
			return Module.CreateSoundAssetIDString(Module.SoundIDs[name])
		end
	end

	-- sound not found
	return Module.CreateSoundAssetIDString(Module.SoundIDs["Default"])
end

-- play any sound
function Module.PlaySound(name: string, volume: number, pace: number, hasAudioOverlap: boolean)
	-- open sound
	local desiredSound: Sound = game.SoundService:FindFirstChild(name)
	if not desiredSound then
		warn("Sound not found: " .. name)
		return
	end

	-- check for audio overlap
	if hasAudioOverlap then
		-- create new sound and place it in sound service
		local new_sound = desiredSound:Clone()
		new_sound.Parent = game.SoundService
		desiredSound = new_sound
	end

	-- configure sound
	desiredSound.Volume = volume * Module.MasterVolume
	desiredSound.PlaybackSpeed = pace

	-- play sound
	desiredSound:Play()

	-- delete if necessary
	if hasAudioOverlap then
		-- delete sound after it is done playing
		desiredSound.Ended:Connect(function()
			desiredSound:Destroy()
		end)
	end
end

-- play a sound at it's original pace
function Module.PlaySound_DefaultSettings(name: string)
	Module.PlaySound(name, 1, 1, true)
end

return Module
