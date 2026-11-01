local Module = {}

-- round manager
export type RoundManager = {
	MaxRoundCount: IntValue,
	CurrentRoundCount: IntValue
}

-- game instance
export type GameInstance = {
	Rounds: RoundManager
}

-- create game
function Module.CreateBasicGame(maxRounds: IntValue): GameInstance
	local newGameInstance: GameInstance = nil
	
	-- setup fields
	newGameInstance.Rounds.MaxRoundCount = maxRounds
	newGameInstance.Rounds.CurrentRoundCount = 0
	
	return newGameInstance
end

-- run game (returns rounds reached)
function Module.RunGame(gameInstance: GameInstance): IntValue
	-- load sounds
	
end

return Module
