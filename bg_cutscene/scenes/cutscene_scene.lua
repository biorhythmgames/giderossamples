-- Class: Cutscene Scene
-- Date: 10/07/2013
-- Author: BiorhythmGames
-- Site: www.biorhythmgames.com
-- Notes: Scene used to play scripted cutscene
--

local tablex = require('core.tablex')
local cutsceneconfig = require('config.cutsceneconfig')

-- optimisation
local tablecount = tablex.count
local strsub = string.sub
local strlen = string.len
local sin = math.sin

-- constants
local CharacterDelay = 0.015
local MaxDialogLines = 6


CutsceneScene = Core.class(Sprite)

function CutsceneScene:init(params)
	self:registerEventListeners()

	-- copy existing systems and objects
	for k,v in pairs(params) do
		self[k] = v
	end

	-- load cutscene
	local gamestate = self.gamestate
	local cutsceneId = gamestate.cutsceneId
	local cutscene = cutsceneconfig.getCutscene(cutsceneId)

	cutscene.initCutscene(self)

	local contentHeight = application:getContentHeight()
	local contentWidth = application:getContentWidth()

	-- initialise name text field
	local nameText = TextField.new(self.font, ' ')
	nameText:setPosition(15, contentHeight - 135)
	nameText:setTextColor(0xff4444)
	self:addChild(nameText)
	self.nameText = nameText

	-- initialise continue text field
	local continueText = TextField.new(self.font, 'CONTINUE')
	continueText:setPosition(contentWidth - continueText:getWidth() - 20, contentHeight - 50)
	continueText:setTextColor(0xffffff)
	continueText:setVisible(false)
	self:addChild(continueText)
	self.continueText = continueText

	-- initialise help text field
	local helpText = TextField.new(self.font, 'TAP TO SKIP')
	helpText:setPosition(contentWidth - helpText:getWidth() - 20, contentHeight - 50)
	helpText:setTextColor(0xffffff)
	helpText:setVisible(false)
	self:addChild(helpText)
	self.helpText = helpText

	-- initialise dialog text fields
	local dialogText = {}
	local textTop = contentHeight - 110
	local spacing = 20
	for i = 1, MaxDialogLines do
		local lineText = TextField.new(self.font, '')
		lineText:setPosition(30, textTop + ((i - 1) * spacing))
		lineText:setTextColor(0xaaaaaa)
		self:addChild(lineText)
		dialogText[i] = lineText
	end
	self.dialogText = dialogText

	local cutsceneTimeline = cutscene.timeline

	-- initialise touch handler
	self:addEventListener(Event.MOUSE_DOWN, function(event)		
			local gamestate = self.gamestate
			if not gamestate.cutsceneActive then
				return
			end

			if self.dialogBlockComplete then
				local newTimeLineIndex = self.timelineIndex + 1

				if newTimeLineIndex > #cutsceneTimeline then
					self:advanceNextScene()
				else
					self:advanceTimeLine()
				end
			else
				self:forceCompleteCurrentDialogBlock()
			end

			event:stopPropagation()
		end)


	-- initialise scripted event processing
	self.timelineIndex = 0
	self.dialogLineIndex = 1
	self.characterIndex = 1
	self.printDelay = 0
	self.dialogBlockComplete = false

	self.cutsceneTimeline = cutsceneTimeline
end

function CutsceneScene:registerEventListeners()
	self:addEventListener('enterBegin', self.onTransitionInBegin, self)
	self:addEventListener('enterEnd', self.onTransitionInEnd, self)
	self:addEventListener('exitBegin', self.onTransitionOutBegin, self)
	self:addEventListener('exitEnd', self.onTransitionOutEnd, self)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)	
end

function CutsceneScene:onTransitionInBegin()
end

function CutsceneScene:onTransitionInEnd()
	self.transitionInComplete = true

	self.gamestate.cutsceneActive = true

	self:advanceTimeLine()
end

function CutsceneScene:onTransitionOutBegin()
end

function CutsceneScene:onTransitionOutEnd()
end

function CutsceneScene:advanceTimeLine()
	self.timelineIndex = self.timelineIndex + 1
	self.dialogLineIndex = 1
	self.characterIndex = 1
	self.printDelay = 0
	self.dialogBlockComplete = false

	local cutsceneTimeline = self.cutsceneTimeline
	local timelineIndex = self.timelineIndex
	local character = cutsceneTimeline[self.timelineIndex].character
	self.nameText:setText(character .. ':')

	for _, text in ipairs(self.dialogText) do
		text:setText('')
	end

	self.continueText:setVisible(false)
	self.helpText:setVisible(true)
end

function CutsceneScene:advanceNextScene()
	local sceneManager = self.sceneManager

	local gamestate = self.gamestate
	gamestate.cutsceneActive = nil
	gamestate.cutsceneId = cutsceneconfig.getNextCutsceneId(gamestate.cutsceneId)

	sceneManager:changeScene('cutscenescene', 1, SceneManager.fade, easing.linear, {
				userData = {
					sceneManager = sceneManager,
					gamestate = self.gamestate,
					font = self.font,
				},
			})

	self.transitionOutInitiated = true
end

function CutsceneScene:setDialogBlockComplete()
	self.dialogBlockComplete = true

	self.glowTime = 0

	self.continueText:setVisible(true)

	self.helpText:setVisible(false)
end

function CutsceneScene:forceCompleteCurrentDialogBlock()
	local cutsceneTimeline = self.cutsceneTimeline
	local timelineIndex = self.timelineIndex
	local dialogLineIndex = self.dialogLineIndex
	local dialogText = self.dialogText

	-- complete current and future lines in block now
	local dialogBlock = cutsceneTimeline[timelineIndex].dialog

	for i = dialogLineIndex, #dialogBlock do
		local sourceLine = dialogBlock[i]
		local displayLine = dialogText[i]
		displayLine:setText(sourceLine)
	end

	self:setDialogBlockComplete()
end

function CutsceneScene:updateContinueButtonGlow(dt)
	local glowTime = self.glowTime or 0
	glowTime = glowTime + (8 * dt)
	local glw = 1-((sin(glowTime)+1) * 0.5)
	self.glowTime = glowTime

	self.continueText:setAlpha(glw)
end

function CutsceneScene:onEnterFrame(event)
	local dt = event.deltaTime
	local time = event.time

	-- no dialog processing during transitions
	if self.transitionOutInitiated then
		return
	end

	if not self.transitionInComplete then
		return
	end

	-- update continue button glow
	if self.dialogBlockComplete then
		self:updateContinueButtonGlow(dt)
	end

	-- wait until user ready for next dialog block
	if self.dialogBlockComplete then
		return
	end

	-- apply pause between character rendering
	local printDelay = self.printDelay
	if printDelay > 0 then
		self.printDelay = printDelay - dt
		return
	end

	-- process scripted timeline
	local cutsceneTimeline = self.cutsceneTimeline
	local timelineIndex = self.timelineIndex

	local dialogBlock = cutsceneTimeline[timelineIndex].dialog

	local dialogLineIndex = self.dialogLineIndex
	local sourceLine = dialogBlock[dialogLineIndex]
	local displayLine = self.dialogText[dialogLineIndex]

	local lineString = strsub(sourceLine, 1, self.characterIndex)
	displayLine:setText(lineString)

	self.characterIndex = self.characterIndex + 1
	self.printDelay = CharacterDelay

	-- detect end of line / end of block
	if self.characterIndex > strlen(sourceLine) then
		self.dialogLineIndex = dialogLineIndex + 1
		self.characterIndex = 1

		if self.dialogLineIndex > #dialogBlock then
			self:setDialogBlockComplete()
		end
	end
end
