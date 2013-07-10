-- Module: First Cutscene
-- Date: 10/07/2013
-- Author: BiorhythmGames
-- Site: www.biorhythmgames.com
-- Notes: Cutscene init & script
--

local T = {}

T._NAME = 'first_cutscene'

T.initCutscene = function(scene)
	-- create biorhythmgames background
	local logoTexture = Texture.new('resources/bglogo.png')
	local logoBitmap = Bitmap.new(logoTexture)

	local contentWidth = application:getContentWidth()
	local contentHeight = application:getContentHeight()
	local logoHeight = logoBitmap:getHeight()

	logoBitmap:setPosition(0, (contentHeight - logoHeight) * 0.5)

	scene:addChild(logoBitmap)

	-- create text content banner
	local bannerHeight = 140
	local baseBorder = 20
	local top = contentHeight - bannerHeight - baseBorder
	local bottom = contentHeight - baseBorder
	local strokeWidth = 1
	local strokeColour = 0xaaaaaa
	local lineAlpha = 1

	local contentRect = Rect.new {
				x = 0, 
				y = top,
				width = contentWidth,
				height = bannerHeight,
				strokeWidth = 0,
				fillColour = 0xcc0000,
				alpha = 0.1,
			}
	scene:addChild(contentRect)

	local line1 = Line.new(0, top, contentWidth, top, strokeWidth, strokeColour, lineAlpha)
	scene:addChild(line1)

	local line2 = Line.new(0, bottom, contentWidth, bottom, strokeWidth, strokeColour, lineAlpha)
	scene:addChild(line2)
end

T.timeline = {
	{
		character = 'ANDREW',
		dialog = {
			'HEY MIKE - HAVE A LOOK AT THIS...',
			'THERE IS A REQUEST FOR HELP ON THE GIDEROS FORUMS.',
			'WE MIGHT BE ABLE TO ASSIST..',
		},
	},
	{
		character = 'MIKE',
		dialog = {
			'YEAH? WHAT DO THEY NEED HELP WITH?',
			'IF THEY WANT TIPS ON PLAYING JOUST, I HAVE IT COVERED',
		},
	},
	{
		character = 'ANDREW',
		dialog = {
			'.....NO',
			'THEY WANT SOME ADVICE ON CUTSCENES.',
			'WE HAVE CUTSCENES IN NEON FORCE, AND COULD GIVE THEM SOME HELP',
		},
	},
	{
		character = 'MIKE',
		dialog = {
			'SOUNDS GOOD.',
			'MAYBE PUT TOGETHER A SMALL DEMO PROJECT?',
		},
	},
	{
		character = 'ANDREW',
		dialog = {
			'EASY. DONE.',
			'THIS SHOULD SERVE AS A DECENT EXAMPLE.',
			'FIND THIS DEMO AND MORE AT WWW.BIORHYTHMGAMES.COM',
		},
	},
}

return T
