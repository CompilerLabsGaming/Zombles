--[[
    Round Manager
]]

-- module
local Module = {}

-- start game
function Module.StartGame(maxRoundID)
    Module.CurrentRoundID = 1
    Module.MaximumRoundID = maxRoundID
    Module.CurrentMonsterCount = 0
    Module.MonstersLeftToSpawn = 0
    Module.MonsterMultiplier = 1
end

-- next round triggered
function Module.WaitForNextRound(): boolean
    return Module.CurrentMonsterCount > 0
end

-- start round
function Module.StartRound()
    Module.CurrentMonsterCount = 0
    Module.MonstersLeftToSpawn = Module.CurrentRoundID * Module.MonsterMultiplier
end

-- spawn monster
function Module.MarkZombieSpawned()
    Module.CurrentMonsterCount += 1
    Module.MonstersLeftToSpawn -= 1
end

-- next round
function Module.NextRound()
    Module.CurrentRoundID += 1;
end

-- game is running
function Module.RunningRounds(): boolean
    return Module.CurrentRoundID > 0 and Module.CurrentRoundID <= Module.MaximumRoundID
end

-- end game
function Module.EndGame()
    Module.RoundID = 0
end

function Module.GetCurrentZombieType(): string
    return "Noob"
end

return Module
