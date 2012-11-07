-- Project: 3D Object Demo
-- Date: 29/10/2012
-- Site: http://www.biorhythmgames.com
-- Contact: andrew@biorhythmgames.com
-- Note: Button config for the demo

local Config = {}

Config._NAME = 'buttonConfig'

Config.buttonTop = 10
Config.buttonLeft = 15
Config.buttonWidth = 50
Config.buttonHeight = 20
Config.buttonSpacing = (Config.buttonHeight + 15)
Config.strokeWidth = 1
Config.fontResource = 'arial10'

Config.buttonAlpha = 1.0
Config.fillColour = 0x00008c
Config.strokeColour = 0x6464dc
Config.textColour = 0xffffff

Config.demoButtons = {
	{
		text = 'Glenz',
		params = {
			mode = 'glenz',
			removeHiddenSurface = false,
			lightMap = false,
			polyAlpha = 0.5,
		},
	},
	{
		text = 'Light',
		params = {
			mode = 'light',
			removeHiddenSurface = true,
			lightMap = true,
			polyAlpha = 1,
		},
	},
	{
		text = 'Flat',
		params = {
			mode = 'flat',
			removeHiddenSurface = true,
			lightMap = false,
			polyAlpha = 1,
		},
	},
	{
		text = 'Wire',
		params = {
			mode = 'wire',
			removeHiddenSurface = true,
			lightMap = false,
			polyAlpha = 1,
		},
	},
	{
		text = 'Vert',
		params = {
			mode = 'vert',
			removeHiddenSurface = false,
			lightMap = false,
		},
	},
}

return Config