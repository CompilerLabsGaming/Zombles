--[[
	Application - The master file for the entire game.
]]

-- load modules
local ServerScripting = game.ServerScriptService
local GameCore = ServerScripting.GameCore
local ScriptingFolder = GameCore.Scripting
local ScriptingLibrariesFolder = ScriptingFolder.Libraries
local Module_LaserGun = require(ScriptingLibrariesFolder.LaserGun)
local Module_PlaySounds = require(ScriptingLibrariesFolder.PlaySounds)

--[[
	Application Types
]]

-- game core
export type ApplicationCore = {
	
}

-- application structure
export type ApplicationStructure = {
	MapSeed: number
}

--[[
	Run Application
]]

-- run application
function RunApplication(application: ApplicationStructure): nil
	-- setup game
	
end
