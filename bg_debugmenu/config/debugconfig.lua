-- Class: Debug Config
-- Date: 26/06/2013
-- Author: BiorhythmGames
-- Site: www.biorhythmgames.com
-- Notes: Sample debug menu config
--

-- optimisation
local max = math.max

-- supported debug commands
local CommandTypes = {
	SpriteMove = 1,
	ShakeOnBounce = 2,
	IncScore = 3,
	DecScore = 4,
	ResetTimer = 5,
	ShakeScreen = 6,
	IncSpeed = 7,
	DecSpeed = 8,
	TimerRunning = 9,
}

-- supported button types
local ButtonTypes = {
	Toggle = 1,
	Push = 2,
}


local T = {}

T._NAME = 'debugmenuconfig'

T.CommandTypes = CommandTypes

T.ButtonTypes = ButtonTypes

T.CommandList = {
	{
		commandType = CommandTypes.SpriteMove,
		description = 'Sprite movement',
		buttonType = ButtonTypes.Toggle,
		getToggleState = function(params)
				return params.gamestate.moveSprite
			end,
	},

	{
		commandType = CommandTypes.ShakeOnBounce,
		description = 'Screen shake on bounce',
		buttonType = ButtonTypes.Toggle,
		getToggleState = function(params)
				return params.gamestate.shakeOnBounce
			end,
	},

	{
		commandType = CommandTypes.IncScore,
		description = 'Increase score',
		buttonType = ButtonTypes.Push,
		buttonText = '+ 1000',
		params = {
			step = 1000,
		},
	},

	{
		commandType = CommandTypes.DecScore,
		description = 'Decrease score',
		buttonType = ButtonTypes.Push,
		buttonText = '- 1000',
		params = {
			step = -1000,
		},
	},

	{
		commandType = CommandTypes.ResetTimer,
		description = 'Reset timer',
		buttonType = ButtonTypes.Push,
		buttonText = 'R.Timer',
		params = {
		},
	},

	{
		commandType = CommandTypes.ShakeScreen,
		description = 'Shake screen',
		buttonType = ButtonTypes.Push,
		buttonText = 'Shake',
		params = {
			shake = 0.5,
			shakeIntensity = 7,
		},
	},

	{
		commandType = CommandTypes.IncSpeed,
		description = 'Increase movement speed',
		buttonType = ButtonTypes.Push,
		buttonText = '+ 20',
		params = {
			step = 20,
		},
	},

	{
		commandType = CommandTypes.DecSpeed,
		description = 'Decrease movement speed',
		buttonType = ButtonTypes.Push,
		buttonText = '- 20',
		params = {
			step = -20,
		},
	},

	{
		commandType = CommandTypes.TimerRunning,
		description = 'Demo timer',
		buttonType = ButtonTypes.Toggle,
		getToggleState = function(params)
				return params.gamestate.timerActive
			end,
	},
}

T.CommandStateFuncs = {
	[CommandTypes.SpriteMove] = function(params)
			local gamestate = params.gamestate
			return gamestate.demoActive
		end,

	[CommandTypes.ShakeOnBounce] = function(params)
			local gamestate = params.gamestate
			return gamestate.demoActive
		end,

	[CommandTypes.IncScore] = function(params)
			local gamestate = params.gamestate
			return gamestate.demoActive
		end,

	[CommandTypes.DecScore] = function(params)
			local gamestate = params.gamestate
			return gamestate.demoActive and gamestate.score > 0
		end,

	[CommandTypes.ResetTimer] = function(params)
			return true
		end,

	[CommandTypes.ShakeScreen] = function(params)
			local gamestate = params.gamestate
			local demoActive = gamestate.demoActive
			local shakeInfo = gamestate.shakeInfo
			local shakeActive = shakeInfo.shake > 0
			return gamestate.demoActive and not shakeActive
		end,

	[CommandTypes.IncSpeed] = function(params)
			local gamestate = params.gamestate
			return gamestate.demoActive
		end,

	[CommandTypes.DecSpeed] = function(params)
			local gamestate = params.gamestate
			return gamestate.demoActive
		end,

	[CommandTypes.TimerRunning] = function(params)
			local gamestate = params.gamestate
			return gamestate.demoActive
		end,
}

T.CommandFunctions = {
	[CommandTypes.SpriteMove] = function(dt, time, gameParams, commandParams)
			local gamestate = gameParams.gamestate
			gamestate.moveSprite = not gamestate.moveSprite
		end,

	[CommandTypes.ShakeOnBounce] = function(dt, time, gameParams, commandParams)
			local gamestate = gameParams.gamestate
			gamestate.shakeOnBounce = not gamestate.shakeOnBounce
		end,

	[CommandTypes.IncScore] = function(dt, time, gameParams, commandParams)
			local gamestate = gameParams.gamestate
			gamestate.score = gamestate.score + commandParams.step
		end,

	[CommandTypes.DecScore] = function(dt, time, gameParams, commandParams)
			local gamestate = gameParams.gamestate
			gamestate.score = max(gamestate.score + commandParams.step, 0)
		end,

	[CommandTypes.ResetTimer] = function(dt, time, gameParams, commandParams)
			local gamestate = gameParams.gamestate
			gamestate.timer = 0
		end,

	[CommandTypes.ShakeScreen] = function(dt, time, gameParams, commandParams)
			local gamestate = gameParams.gamestate
			gamestate.shakeInfo.shake = 1
			gamestate.shakeInfo.shakeIntensity = 5
		end,

	[CommandTypes.IncSpeed] = function(dt, time, gameParams, commandParams)
			local gamestate = gameParams.gamestate
			gamestate.movementSpeed = gamestate.movementSpeed + commandParams.step
		end,

	[CommandTypes.DecSpeed] = function(dt, time, gameParams, commandParams)
			local gamestate = gameParams.gamestate
			gamestate.movementSpeed = max(gamestate.movementSpeed + commandParams.step, 1)
		end,

	[CommandTypes.TimerRunning] = function(dt, time, gameParams, commandParams)
			local gamestate = gameParams.gamestate
			gamestate.timerActive = not gamestate.timerActive
		end,
}

return T