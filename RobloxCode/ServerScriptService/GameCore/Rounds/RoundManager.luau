--[[
    Round Manager
]]

-- module
local RoundManager = {}

-- start game
function RoundManager.StartGame(maxRoundID)
    RoundManager.CurrentRoundID = 1
    RoundManager.MaximumRoundID = maxRoundID
    RoundManager.CurrentMonsterCount = 0
    RoundManager.MonstersLeftToSpawn = 0
    RoundManager.MonsterMultiplier = 4
end

-- next round triggered
function RoundManager.WaitForNextRound(): boolean
    return RoundManager.CurrentMonsterCount > 0
end

-- start round
function RoundManager.StartRound()
    RoundManager.CurrentMonsterCount = 0
    RoundManager.MonstersLeftToSpawn = RoundManager.CurrentRoundID * RoundManager.MonsterMultiplier
end

-- spawn monster
function RoundManager.MarkZombieSpawned()
    RoundManager.CurrentMonsterCount += 1
    RoundManager.MonstersLeftToSpawn -= 1
end

-- next round
function RoundManager.NextRound()
    RoundManager.CurrentRoundID += 1;
end

-- game is running
function RoundManager.RunningRounds(): boolean
    return RoundManager.CurrentRoundID > 0 and RoundManager.CurrentRoundID <= RoundManager.MaximumRoundID
end

-- end game
function RoundManager.EndGame()
    RoundManager.RoundID = 0
end

function RoundManager.GetCurrentZombieType(): string
    return "Ash"
end

return RoundManager
