--[[
    Game States
]]

--[[
    Round Information
]]

-- module
local GameStates = {}

-- start game
function GameStates.StartGame()
    GameStates.RoundID = 1
end

-- next round
function GameStates.NextRound()
    GameStates.RoundID += 1;
end

-- get current round
function GameStates.GetCurrentRoundID()
    return GameStates.RoundID
end

-- end game
function GameStates.EndGame()
    GameStates.RoundID = 0
end

function GameStates.GetCurrentZombieType(): string
    return "squidward"
end

return GameStates
