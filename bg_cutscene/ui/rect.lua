-- Class: Rect
-- Date: 10/07/2013
-- Author: BiorhythmGames
-- Site: www.biorhythmgames.com
-- Notes: Generic rectangle class

Rect = Core.class(Sprite)

function Rect:init(params)
	local width = params.width
	local height = params.height

	local background = Shape.new()
	background:setLineStyle(params.strokeWidth, params.strokeColour)
	background:setFillStyle(Shape.SOLID, params.fillColour)
	background:beginPath()
	background:moveTo(0, 0)
	background:lineTo(width, 0)
	background:lineTo(width, height)
	background:lineTo(0, height)
	background:closePath()
	background:endPath()
	self:addChild(background)

	self:setAlpha(params.alpha or 1)			
	self:setPosition(params.x, params.y)
end
