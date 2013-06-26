-- Class: Demo Scene
-- Date: 26/06/2013
-- Author: BiorhythmGames
-- Site: www.biorhythmgames.com
-- Notes: Scene used for Debug Menu demo
--

local shakehelper = require('shake.shakehelper')

-- optimisation
local min = math.min
local max = math.max


DemoScene = Core.class(Sprite)

function DemoScene:init(params)
	-- initialise event listeners
	self:registerEventListeners()

	-- copy existing systems and objects
	for k,v in pairs(params) do
		self[k] = v
	end

	-- create biorhythmgames background
	local logoTexture = Texture.new('resources/bglogo.png')
	local logoBitmap = Bitmap.new(logoTexture)

	local contentWidth = application:getContentWidth()
	local contentHeight = application:getContentHeight()
	local logoHeight = logoBitmap:getHeight()

	logoBitmap:setPosition(0, (contentHeight - logoHeight) * 0.5)

	self:addChild(logoBitmap)

	-- create biorhythmgames icon
	local iconTexture = Texture.new('resources/icon-128.png', true)
	local iconBitmap = Bitmap.new(iconTexture)
	local iconX = math.random(100, 600)
	local iconY = math.random(50, 300)
	iconBitmap:setPosition(iconX, iconY)
	iconBitmap:setAlpha(0.7)
	self:addChild(iconBitmap)
	self.iconBitmap = iconBitmap

	-- create score text
	local scoreText = TextField.new(params.font, string.format('Score: %08d', 0))
	scoreText:setPosition(50, 300)
	scoreText:setTextColor(0xeeeeee)
	self:addChild(scoreText)
	self.scoreText = scoreText
	self.oldScore = 0

	-- create timer text
	local timerText = TextField.new(params.font, string.format("Timer: %10.2f", 0))
	timerText:setPosition(50, 330)
	timerText:setTextColor(0xeeeeee)
	self:addChild(timerText)
	self.timerText = timerText

	-- initialise sprite movement
	local gamestate = self.gamestate
	gamestate.movementSpeed = 120
	gamestate.movementVec = {
		x = math.random() < 0.5 and -1 or 1,
		y = math.random() < 0.5 and -1 or 1,
	}
end

function DemoScene:registerEventListeners()
	self:addEventListener('enterBegin', self.onTransitionInBegin, self)
	self:addEventListener('enterEnd', self.onTransitionInEnd, self)
	self:addEventListener('exitBegin', self.onTransitionOutBegin, self)
	self:addEventListener('exitEnd', self.onTransitionOutEnd, self)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)	
end

function DemoScene:onTransitionInBegin()
end

function DemoScene:onTransitionInEnd()
	self.gamestate.demoActive = true
end

function DemoScene:onTransitionOutBegin()
end

function DemoScene:onTransitionOutEnd()
end

function DemoScene:registerShake()
	local gamestate = self.gamestate
	local shakeInfo = gamestate.shakeInfo

	if gamestate.shakeOnBounce then
		shakeInfo.shake = 0.5
		shakeInfo.shakeIntensity = 10
	end
end

function DemoScene:updateDemoTimer(dt, time, updateParams)
	local gamestate = updateParams.gamestate

	if not gamestate.timerActive then
		return
	end

	gamestate.timer = gamestate.timer + dt

	self.timerText:setText(string.format("Timer: %10.2f", gamestate.timer))
end

function DemoScene:updateDemoScore(dt, time, updateParams)
	local gamestate = updateParams.gamestate
	local currentScore = gamestate.score

	if currentScore ~= self.oldScore then
		self.scoreText:setText(string.format("Score: %08d", currentScore))
		self.oldScore = currentScore
	end
end

function DemoScene:updateSpriteMovement(dt, time, updateParams)
	local gamestate = updateParams.gamestate

	if not gamestate.moveSprite then
		return
	end

	local iconBitmap = self.iconBitmap

	-- determine upper clamp
	local contentWidth = application:getContentWidth() - iconBitmap:getWidth()
	local contentHeight = application:getContentHeight() - iconBitmap:getHeight()

	-- determine distance covered
	local movementVec = gamestate.movementVec
	local step = gamestate.movementSpeed * dt

	-- determine new position
	local newX = iconBitmap:getX() + (movementVec.x * step)
	local newY = iconBitmap:getY() + (movementVec.y * step)

	-- detect & register collision with side
	if newX < 0 or newX > contentWidth then
		movementVec.x = -movementVec.x
		self:registerShake()
	end

	if newY < 0 or newY > contentHeight then
		movementVec.y = -movementVec.y
		self:registerShake()
	end

	-- clamp position to screen
	local clampedX = max(min(newX, contentWidth), 0)
	local clampedY = max(min(newY, contentHeight), 0)

	iconBitmap:setX(clampedX)
	iconBitmap:setY(clampedY)
end

function DemoScene:onEnterFrame(event)
	local dt = event.deltaTime
	local time = event.time

	local updateParams = {
		gamestate = self.gamestate,
		scene = self,
	}

	-- update demo score
	self:updateDemoScore(dt, time, updateParams)

	-- update demo timer
	self:updateDemoTimer(dt, time, updateParams)

	-- update sprite movement
	self:updateSpriteMovement(dt, time, updateParams)

	-- update debug system
	self.debugMenu:update(dt, time, updateParams)

	-- update active shake
	shakehelper.updateShake(dt, updateParams)
end
