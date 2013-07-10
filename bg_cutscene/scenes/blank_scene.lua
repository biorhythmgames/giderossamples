-- Class: Blank Scene
-- Date: 10/07/2013
-- Author: BiorhythmGames
-- Site: www.biorhythmgames.com
-- Notes: Empty scene
--

BlankScene = Core.class(Sprite)

function BlankScene:init(params)
end

function BlankScene:registerEventListeners()
	self:addEventListener('enterBegin', self.onTransitionInBegin, self)
	self:addEventListener('enterEnd', self.onTransitionInEnd, self)
	self:addEventListener('exitBegin', self.onTransitionOutBegin, self)
	self:addEventListener('exitEnd', self.onTransitionOutEnd, self)
end

function BlankScene:onTransitionInBegin()
end

function BlankScene:onTransitionInEnd()
end

function BlankScene:onTransitionOutBegin()
end

function BlankScene:onTransitionOutEnd()
end
