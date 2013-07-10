-- Module: Second Cutscene
-- Date: 10/07/2013
-- Author: BiorhythmGames
-- Site: www.biorhythmgames.com
-- Notes: Cutscene init & script
--

local T = {}

T._NAME = 'second_cutscene'

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
		character = 'Andrew',
		dialog = {
			'A NEW CUTSCENE, AND SOME NEW DIALOG CONTENT REQUIRED..',
			'RUNNING SHORT ON IDEAS',
			'ANY THOUGHTS MIKE?',
		},
	},
	{
		character = 'Mike',
		dialog = {
			'JUST MAKE SOMETHING UP.',
			'IT ONLY NEEDS TO COVER A FEW DIALOG BOXES',
		},
	},
	{
		character = 'Andrew',
		dialog = {
			'HOW ABOUT WE HIT THE BOWLING ALLEY NEXT WEEK?',
			'AND MAYBE DOUBLE IT AS A DESIGN SESSION FOR NEON FORCE...',
		},
	},
	{
		character = 'Mike',
		dialog = {
			'SOUNDS GOOD!',
			'THEN WE SHOULD HAVE SOME 2 PLAYER JOUST ON THE ATARI LYNX.',
			'...AND WORK ON THE GAME TOO...',
		},
	},
	{
		character = 'Andrew',
		dialog = {
			'SOUNDS LIKE A PLAN.',
			'HEY - THAT HAS MANAGED TO FILL THE DIALOG FOR THE CUTSCENE.',
		},
	},
	{
		character = 'Mike',
		dialog = {
			'AWESOME!',
			'WE ARE DONE.',
		},
	},
}

return T