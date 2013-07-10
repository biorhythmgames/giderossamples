-- Project: Cutscene Demo
-- Date: 10/07/2013
-- Author: BiorhythmGames
-- Site: www.biorhythmgames.com
-- Info: Cutscene demo designed for GiderosSDK


-- set the orientation
application:setOrientation(Application.LANDSCAPE_RIGHT)

-- setup the background
application:setBackgroundColor(0x000000)

-- initialise scene manager
local sceneManager = SceneManager.new {
			['blankscene'] = BlankScene,
			['cutscenescene'] = CutsceneScene,
		}

stage:addChild(sceneManager)

-- load font
local fontName = 'consolas18'
local fontText = string.format('font/%s.txt', fontName)
local fontImage = string.format('font/%s.png', fontName)
local smallFont = Font.new(fontText, fontImage, true)

-- initialise gamestate
local gamestate = {
	cutsceneId = 1,
}

-- begin demo
sceneManager:changeScene('blankscene')
sceneManager:changeScene('cutscenescene', 1, SceneManager.fade, easing.linear, {
			userData = {
				sceneManager = sceneManager,
				gamestate = gamestate,
				font = smallFont,
			},
		})
