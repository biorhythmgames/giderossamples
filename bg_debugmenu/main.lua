-- Project: Debug Menu Demo
-- Date: 26/06/2013
-- Author: BiorhythmGames
-- Site: www.biorhythmgames.com
-- Info: Demo of the debug menu system using GiderosSDK


-- set the orientation
application:setOrientation(Application.LANDSCAPE_RIGHT)

-- setup the background
application:setBackgroundColor(0x000000)

-- initialise scene manager
local sceneManager = SceneManager.new {
			['blankscene'] = BlankScene,
			['demoscene'] = DemoScene,
		}

stage:addChild(sceneManager)

-- load font
local fontName = 'consolas14'
local fontText = string.format('font/%s.txt', fontName)
local fontImage = string.format('font/%s.png', fontName)
local smallFont = Font.new(fontText, fontImage, true)

-- initialise gamestate
local gamestate = {
	score = 0,
	timer = 0,
	moveSprite = true,
	timerActive = true,
	shakeOnBounce = true,
	shakeInfo = {
		shake = 0,
		shakeIntensity = 4,
	},
}

-- initialise debug menu sysem
local debugMenu = DebugMenu.new {
		font = smallFont,
		showMenuToggle = true,
	}

stage:addChild(debugMenu)

-- begin demo
sceneManager:changeScene('blankscene')
sceneManager:changeScene('demoscene', 1, SceneManager.fade, easing.linear, {
			userData = {
				sceneManager = sceneManager,
				gamestate = gamestate,
				debugMenu = debugMenu,
				font = smallFont,
			},
		})
